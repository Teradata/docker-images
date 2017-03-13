FROM ubuntu

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y sudo

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y git

RUN useradd -m -s /bin/bash spark

USER spark
WORKDIR /home/spark
RUN git clone https://github.com/apache/spark.git
RUN cd spark && git checkout v1.2.0

WORKDIR /home/spark/spark
RUN sbt/sbt -Phive -Phive-thriftserver assembly

ENTRYPOINT ["bin/spark-sql"]
