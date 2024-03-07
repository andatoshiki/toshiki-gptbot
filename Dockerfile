FROM rust:latest AS BUILD
WORKDIR /usr/src/tkgpt

COPY src/ src/
COPY Cargo.* .
RUN cargo install --path . 

FROM debian:latest
WORKDIR /tkgpt/

COPY --from=BUILD /usr/src/tkgpt/target/release/tkgpt /tkgpt/tkgpt
COPY LICENSE .
COPY boot.sh .

# install dependencies
#   libsqlite3.so.0: cannot open shared object file
#   failed:../ssl/statem/statem_clnt.c:1914
RUN apt update -y && \ 
    apt install -y --no-install-recommends libsqlite3-dev sqlite3 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

CMD ["/tkgpt/boot.sh"]
