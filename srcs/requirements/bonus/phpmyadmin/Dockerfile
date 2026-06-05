FROM debian:bookworm

RUN apt update && apt install -y php8.2 php8.2-mysql php8.2-mbstring wget unzip && apt clean

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip && \
    unzip phpMyAdmin-latest-all-languages.zip && \
    rm phpMyAdmin-latest-all-languages.zip && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin

RUN echo '<?php $cfg["Servers"][1]["host"] = "mariadb"; ?>' > /var/www/html/phpmyadmin/config.inc.php

EXPOSE 8081

CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html/phpmyadmin"]
