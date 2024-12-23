# README

Пока что тут тупо шаблон от рельсы и небольшие настройки докера.

## Начало работы

Вам нужно тупо клонировать этот репозиторий в какую-нибудь папку либо через CLI

```bash
git clone https://github.com/Dkoplik/effective-octo-potato.git
```

либо использовать какой-нибудь GUI по типу GitHub Desktop.

Вроде как докер под разработку я настроил, так что, в теории, вам даже сам руби на системе не нужен, нужен только Docker Engine (он же Docker CE), гайды по его установке:

- На Ubuntu (или винда + WSL с Ubuntu): https://docs.docker.com/engine/install/ubuntu/

- На винду (без WSL) проще установить вместе с Docker Desktop, тогда будет для докера ещё и GUI, но я по нему не шарю: https://www.docker.com/

Теперь надо просто открыть терминал в директории с проектом (куда вы его там клонировали) и ввести команду:

```bash
docker compose up
```

Если выдаёт ошибку `permission denied`, то в самом начале команды напишите ещё `sudo`.

После успешного выполнения команды, у вас должен появиться image проекта и сразу же запуститься его контейнер. Если ничего не сломалось, то у вас должен работать [localhost:3000](http://localhost:3000/).

Для завершения работы контейнера введите:

```bash
docker compose down
```

### Про отслеживание изменений

Тут пока не очень разобрался, например, в реплите же можно было изменить файл, сохранить, и изменения сами подтянутся.

Это точно можно организовать через флаг `--watch` при запуске контейнера(-ов):

```bash
docker compose up --watch
```

Но при этом в `compose.yaml` я вроде указал, чтобы локальная папка проекта была связана с соответствующей папкой в контейнере, так что вроде как все изменения на локальном диске должны попадать в контейнер, но как на это рельса реагирует, пока не проверил.

В общем, если для проверки сайта надо будет постоянно поднимать и отключать контейнер, то пишите флаг `--watch` и проблем быть не должно.

## VS Code

Запустить то проект можно и совсем без руби, но чтобы удобно писать код его всё же необходимо установить. У нас ruby 3.3.6.

В самом VS Code надо будет установить следующие расширения:

- Ruby LSP

- Ruby Sorbet

Ещё неплохо бы расширения для unit-тестов поставить, но я ими пока не занимался.

После этого надо прописать `bundle install`, чтобы у вас локально необходимые для работы плагинов гемы появились.

Далее жмёте сочетание клавиш `Ctrl + Shift + P`, выбираете пункт с открытием настроек рабочего пространства (json) и вставляете внуть фигурных скобок вот этот текст:

```json
"sorbet.lspConfigs": [{
    "id": "stable",
    "name": "Sorbet",
    "description": "Stable Sorbet Ruby IDE features",
    "cwd": "${workspaceFolder}",
    "command": [
      "bundle",
      "exec",
      "srb",
      "typecheck",
      "--lsp"
    ]
}]
```

После этого всякие подсказки для ruby должны работать.

## Про Godot

Пока вообще не добавлял его, сейчас надо разобраться, куда исходники для игры пихать и куда потом сам бинарник размещать. Более того, для CI надо будет эту дичь как-то автоматизировать + под Godot игру тоже желательны тесты и линтер, а ещё саму игру надо как-то собирать во время сборки image для докера.

В теории, наверное, правильнее было бы бекенд сайта на рельсе и саму игру на Godot сделать в разных репозиториях, но я хз как их потом собирать вместе, так что буду костылить это сюда.