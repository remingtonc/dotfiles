FROM allinurl/goaccess:alpine
WORKDIR /
COPY loop_goaccess.sh .
RUN chmod +x loop_goaccess.conf
COPY goaccess.conf /etc/goaccess.conf
CMD sh loop_goaccess.sh