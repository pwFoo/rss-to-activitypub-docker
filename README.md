# rss-to-activity-pub-docker

[rss-to-activity-pub](https://github.com/dariusk/rss-to-activitypub) dockerized

1. Clone the `rss-to-activity-pub` repository and move into it :
    ```shell
    $ git clone https://github.com/dariusk/rss-to-activitypub && cd rss-to-activitypub
    ```
    From now on all commands have to be executed in this directory.
2. Clone the `rss-to-activity-pub-docker` repository a folder named `docker` :
    ```shell
    $ git clone https://framagit.org/husimo/rss-to-activity-pub-docker docker
    ```
3. Optional - if you want to compile on another platform, in `docker/Dockerfile` :
    - First line, replace `node:alpine` by `arm32v6/node:alpine` for `arm32v6` platform (ex: Raspberry Pi).
    - First line `node:alpine` by `arm64v8/node:alpine` for `arm64v8` platform (ex: Scaleway ARM)
4. Compile the image, be sure to be in `rss-to-activity-pub` root directory to provide the good context (source code) to Docker build. Note that red warnings will be displayed on screen as result of node compilation.
    ```shell
    $ sudo docker build -f docker/Dockerfile -t rss-to-activity-pub .
    ```
    You should have that output at the end :
    ```
    Successfully built xxxxxxxxxx
    Successfully tagged rss-to-activity-pub:latest
    ```
5. Create the data directory in docker folder. All application data will be stored there.
    ```shell
    $ mkdir docker/data
    ```
6. Next, you have **two choices**.
    1. If you don't use any reverse proxy. 
        1. copy the `docker-compose.yml.dist` file to `docker-compose.yml` and open it :
            ```shell
            $ cp docker/docker-compose.yml.dist docker/docker-compose.yml && nano docker/docker-compose.yml
            ```
        2. At the line `- DOMAIN=mydomain.tld` you have to replace `mydomain.tld` by your domain name.
        3. Optional (not tested) - if you provide a SSL certificate, you have to :
            1. Put your key and certificate in `docker/data` folder.
            2. Uncomment `#    volumes:` and `#       - "443:443"` lines.
            3. Line `#     - PRIVKEY_PATH=/app/privkey_path` replace `privkey_path` by the name of you private key file with its extension and uncomment the line.
            4. Line `#      - ./data/privkey_path:/app/privkey_path` replace `privkey_path` by the name of you private key file with its extension and uncomment the line.
            5. Line `#     - CERT_PATH=/app/cert_path` replace `cert_path` by the name of you certificate file with its extension and uncomment the line.
            6. Line `#      - ./data/cert_path:/app/cert_path` replace `cert_path` by the name of you certificate file with its extension and uncomment the line.
        4. Optional - if you want to override HTTP or HTTPS port, you have to replace the previous one by yours.
        5. Optional - if you want to disable HTTP, just comment the line `       - "80:80".
        6. Don't uncomment `#      - ./data/bot-node.db:/app/bot-node.db`, we'll do it a bit later, once the container is started.
    2. If you use **traefik proxy** as your reverse proxy. If you use another reverse proxy, sorry, you're on your own.
        1. Copy `docker-compose-traefik.yml.dist` file to `docker-compose.yml` and open it :
            ```shell
            $ cp docker/docker-compose-traefik.yml.dist docker/docker-compose.yml && nano docker/docker-compose.yml
            ```
        2. You have to replace multiple occurencies of **mydomain.tld** in the file by your domain.
        3. If you traefik-proxy is not named `traefik-proxy`, you must replace all occurencies of it with yours in the file.
        3. Don't uncomment `#      - ./data/bot-node.db:/app/bot-node.db` nor `#    volumes:`, we'll do it a bit later, one the container is started.
7. Start you container using that command and display the log :
    ```shell
    $ sudo docker-compose -f docker/docker-compose.yml up -d && sudo docker-compose -f docker/docker-compose.yml logs -f
    ```
8. Once you have `Express server listening on port XXXX`, you can type **[Ctrl+C]** to quit the log command. If not, you may have missed a step.
9. In order to persist your database you now have to save the sqlite3 database created in the first execution of the container in your machine filesystem. Execute the following command : 
    ```
    $ sudo docker exec rss-to-activity-pub cat /app/bot-node.db > docker/data/bot-node.db
    ```
10. In `docker/docker-compose.yml`, you have to :
    1. Uncomment `#      - ./data/bot-node.db:/app/bot-node.db`
    2. If it's not already the case, uncomment `#    volumes:` too.
11. Finally, recreate your container which will have the database persisted :
    ```
    $ sudo docker-compose -f docker/docker-compose.yml up -d
    ```

    
