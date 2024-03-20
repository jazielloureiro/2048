FROM alpine:latest

RUN apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/v3.16/main vim=8.2.5000-r1

WORKDIR /root/.vim

COPY . .

CMD vim -c "exe 'Start2048 rows=${ROWS:-4} cols=${COLS:-4} limit=${LIMIT:-2048}' | q!"