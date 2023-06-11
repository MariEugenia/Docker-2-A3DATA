#Define a imagem a ser utilizada (Jupyter Notebook para Spark)
FROM jupyter/pyspark-notebook:latest

# Define as variáveis e seus respectivo valores (Versões do Hadoop e AWS)
ARG HADOOP_VERSION=3.3.1
ARG AWS_SDK_VERSION=1.11.901

# Define o Usuário que fará as execuções.
USER root

# Roda o comando que acessa o link e faz a requisição web do arquivo de saída.
RUN wget -q "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar" -P /usr/local/jars/ && \
    wget -q "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar" -P /usr/local/jars/

# Definições Spark para a preparação do ambiente. 
RUN echo 'spark.driver.extraClassPath /usr/local/jars/*' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.serializer org.apache.spark.serializer.KryoSerializer' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.fast.upload True' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem' >> "${SPARK_HOME}/conf/spark-defaults.conf"

# Posso passar várias versões que eu quiser nesse arquivo.
COPY requirements.txt requirements.txt

# Roda o arquivo requirements.
RUN pip install -r requirements.txt && \
    pip install "jupyterlab>=3" "ipywidgets>=7.6"