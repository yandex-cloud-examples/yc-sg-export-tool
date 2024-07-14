# Yandex Cloud Security Groups Export Tool

## Обзор <a id="overview"/></a>

Инструмент предназначен для выгрузки списка всех [групп безопасности](https://yandex.cloud/ru/docs/vpc/concepts/security-groups) (SG) для заданного облака ([cloud-id](https://yandex.cloud/ru/docs/resource-manager/operations/cloud/get-id)).

Результатом работы инструмента является файл в [формате CSV](https://ru.wikipedia.org/wiki/CSV) вида `cloud-<cloud-id>-sg-list.csv`. 


## Подготовка инструмента к работе <a id="install"/></a>

Перед использованием инструмент нужно развернуть. Для этого необходимо:

1. Убедиться, что все необходимые инструменты установлены и настроены:
* `yc CLI` - [установлен](https://yandex.cloud/ru/docs/cli/operations/install-cli) и [настроен](https://yandex.cloud/ru/docs/cli/operations/profile/profile-create#create).
* `jq` - [установлен](https://jqlang.github.io/jq/download/).


2. Загрузить решение из репозитория на [github.com](https://github.com/yandex-cloud-examples/yc-sg-export-tool):
```bash
git clone https://github.com/yandex-cloud-examples/yc-sg-export-tool.git
```

3. Перейти в папку с инструментом
```bash
cd yc-sg-export-tool.git
```

## Порядок использования <a id="userguide"/></a>

При запуске инструмента необходимо указать `cloud-id` облака из которого нужно выгрузить информацию о группах безопасности.

```bash
./yc-sg-export.sh ./b1g22jx2133dpa3yvxc3
Processing folder: folder1
Processing folder: folder2
...
Processing folder: folderN

SG Report file: cloud-b1g22jx2133dpa3yvxc3-sg-list.csv
```
