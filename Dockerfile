FROM openeuler/openeuler:23.03 as BUILDER
RUN dnf update -y && \
    dnf install -y golang && \
    go env -w GOPROXY=https://goproxy.cn,direct

MAINTAINER zengchen1024<chenzeng765@gmail.com>

# build binary
WORKDIR /go/src/github.com/opensourceways/robot-gitee-synchronizer
COPY . .
RUN GO111MODULE=on CGO_ENABLED=0 go build -a -o robot-gitee-synchronizer .

# copy binary config and utils
FROM openeuler/openeuler:22.03
RUN dnf -y update && \
    dnf in -y shadow && \
    groupadd -g 1000 synchronizer && \
    useradd -u 1000 -g synchronizer -s /bin/bash -m synchronizer

USER synchronizer

COPY  --chown=synchronizer --from=BUILDER /go/src/github.com/opensourceways/robot-gitee-synchronizer/robot-gitee-synchronizer /opt/app/robot-gitee-synchronizer

ENTRYPOINT ["/opt/app/robot-gitee-synchronizer"]
