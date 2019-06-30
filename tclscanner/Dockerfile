FROM python:3.7

LABEL org.label-schema.name="tclscanner" \
      org.label-schema.description="wrapper for tclscan" \
      org.label-schema.vcs-url="https://github.com/simonkowallik/docker" \
      org.label-schema.vendor="Simon Kowallik"

ENV TCLSCAN_REPO="https://github.com/aidanhs/tclscan.git"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/:/root/.cargo/bin:$PATH"

WORKDIR /build

COPY files/57E7C6324F81391D.asc /build/57E7C6324F81391D.asc

RUN echo "* install packages" \
&&  apt update -y \
&&  apt install -y \
          clang \
          curl \
          git \
          jq \
          less \
          make \
          tcl-dev \
          tzdata \
          vim \
           \
&& echo "* remove default rust + tcl install" \
&&  apt remove -y \
          cargo \
          rustc \
          tcl8.6 \
&& apt autoremove -y

RUN echo "* download, compile, then install tcl" \
&&  cd /build \
&& curl -sSf -LO http://archive.ubuntu.com/ubuntu/pool/universe/t/tcl8.4/tcl8.4_8.4.20-8.dsc \
&& curl -sSf -LO http://archive.ubuntu.com/ubuntu/pool/universe/t/tcl8.4/tcl8.4_8.4.20.orig.tar.gz \
&& gpg --import 57E7C6324F81391D.asc \
&& gpg --verify tcl8.4_8.4.20-8.dsc \
&& grep "$(sha256sum tcl8.4_8.4.20.orig.tar.gz | cut -d' ' -f1)" tcl8.4_8.4.20-8.dsc > /dev/null \
&& echo "* tcl8.4 verified successfully" \
&& tar xzf tcl8.4_8.4.20.orig.tar.gz \
&&  cd /build/tcl8.4.20/unix \
&&  ./configure --enable-64bit --prefix=/usr \
&&  make \
&&  make install \
&& rm -rf /build/tcl8.4_8.4.20.orig.tar.gz /build/tcl8.4.20 /build/tcl8.4_8.4.20-8.dsc /build/57E7C6324F81391D.asc;

COPY files/tclscan.patch /build/tclscan.patch

RUN echo "* install rust nightly-2019-06-28" \
&&  curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2019-06-28 \
&&  rustup component add rustfmt;

VOLUME /scandir

WORKDIR /scandir

COPY files/docker-entrypoint.sh /docker-entrypoint.sh
COPY files/compile.sh /compile.sh
COPY files/tclscanner.py /tclscanner.py
COPY files/tcl/* /scandir/

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["tclscanner.py"]
