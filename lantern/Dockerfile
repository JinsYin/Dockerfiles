FROM busybox:glibc

COPY ./lantern_linux_amd64.xz /lantern_linux_amd64.xz
RUN xz -d /lantern_linux_amd64.xz
RUN mv /lantern_linux_amd64 /lantern
RUN chmod +x /lantern

CMD ["/lantern", "-addr", "0.0.0.0:8787"]