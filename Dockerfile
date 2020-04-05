FROM debian:latest

WORKDIR /app

RUN apt-get update && apt-get install -y wget gpg

# Setup Microsoft packages
RUN wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget https://packages.microsoft.com/config/debian/10/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get update

# Install python and jupyter
RUN apt-get install -y python3-pip python3-dev
RUN pip3 install jupyter

# Install dotnet
RUN apt-get install -y apt-transport-https
RUN apt-get install -y dotnet-sdk-3.1

# Install dotnet interactive
RUN dotnet tool install -g Microsoft.dotnet-interactive
ENV PATH="~/.dotnet/tools:${PATH}"
RUN dotnet interactive jupyter install
RUN jupyter kernelspec list

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Copy demo notebooks
COPY notebooks ./

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''" ]