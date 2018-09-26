FROM adminer:fastcgi
USER root
RUN cd /var/www && mv html adminer && mkdir html && chown adminer:adminer html && mv adminer html/
USER    adminer
