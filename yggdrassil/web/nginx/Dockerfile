FROM nginx:alpine
COPY start.sh .
COPY reload.sh .
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d
ENTRYPOINT [ "sh" ]
CMD [ "start.sh" ]
