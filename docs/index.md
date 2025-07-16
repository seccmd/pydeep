# MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.



## Install

```
uv venv
.venv\Scripts\activate
uv pip install mkdocs-material
```

## Creating-your-site 

```
mkdocs new .

.
├─ docs/
│  └─ index.md
└─ mkdocs.yml

theme:
  name: material
```
  
## Run

```
mkdocs serve
```