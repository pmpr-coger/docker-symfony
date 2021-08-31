# IMAGEM CONTENDO REQUISITOS DO SYMFONY E OUTROS PACOTES RELEVANTES

## DIRETÓRIO DE TRABALHO:
```bash
/srv/app
```
A opção "-v $PWD:/srv/app" deve ser utilizada para montar a pasta de arquivos do projeto no container.

## PORTA CONFIGURADA NO SYMFONY:
```bash
443
``` 
A opção "-p 443:443" pode ser utilizada para expor a porta do container.

## ARQUIVO DE CONFIGURAÇÃO DO PHP:
```bash
/usr/local/etc/php/php.ini
```
A opção "-v $PWD/my-php.ini:/usr/local/etc/php/php.ini" pode ser utilizada para utilizar uma configuração específica.

Segue o exemplo para copiar a versão que está sendo utilizada no container:
```bash
$ docker run --rm pmprcoger/symfony:latest cat /usr/local/etc/php/php.ini > my-php.ini
```

## MÓDULOS DO PHP INSTALADOS:

- amqp
- apcu
- Core
- ctype
- curl
- date
- dom
- fileinfo
- filter
- ftp
- gd
- hash
- iconv
- igbinary
- intl
- json
- libxml
- mbstring
- mysqlnd
- openssl
- pcre
- PDO
- pdo_pgsql
- pdo_sqlite
- Phar
- posix
- readline
- redis
- Reflection
- session
- SimpleXML
- sodium
- SPL
- sqlite3
- standard
- tokenizer
- xdebug
- xml
- xmlreader
- xmlwriter
- xsl
- Zend OPcache
- zip
- zlib

## MÓDULOS ZEND INSTALADOS:

- Xdebug
- Zend OPcache

## VERSÕES INSTALADAS:
PHP 8.0.10 (cli) (built: Aug 26 2021 22:34:15) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.10, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.10, Copyright (c), by Zend Technologies


[32mComposer[39m version [33m2.1.6[39m 2021-08-19 17:11:08


Symfony CLI version [32mv4.25.6[39m (2021-08-27T08:30:27+0000 - stable)
