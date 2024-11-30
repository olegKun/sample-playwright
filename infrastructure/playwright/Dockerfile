# Use the Playwright official image as the base
FROM mcr.microsoft.com/playwright:focal

# Install Java (OpenJDK 11)
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean;

# Set the environment variable for Java (optional, helps if you need to run Java programs directly)
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Verify that both Playwright and Java are installed
RUN java -version

# You can add any additional configurations or dependencies here