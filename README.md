# 2048

2048 game in Vim.

## Screenshots

![Screenshot](https://i.ibb.co/F6bg1BY/Screenshot-1.png)
![Screenshot](https://i.ibb.co/pddJDjn/Screenshot-2.png)
![Screenshot](https://i.ibb.co/7YCy55Z/Screenshot-3.png)

## Installation

You can install this game manually by copying each directory of this repository to your `.vim` directory, but It's recommended to use a plugin manager like [vim-plug](https://github.com/junegunn/vim-plug).

### [vim-plug](https://github.com/junegunn/vim-plug)

- Add to your `.vimrc`:

```vim
Plug 'jazielloureiro/2048'
```

- And then, run the commands:

```vim
:source %
:PlugInstall
```

### [Docker](https://hub.docker.com/r/jazielloureiro/2048)

- Additionally, this game can also be played in a Docker container:

```sh
docker run -it jazielloureiro/2048
```

## Usage

Launch the game with the command:

```vim
:Start2048
```

- Press **h**, **j**, **k**, **l** to move.

- Press **r** to restart the game.

- Press **q** to quit.

### Options

`:Start2048` can be called with these arguments.

- `rows=`: It must be followed by a number from 2 to 20.

- `cols=`: It must be followed by a number from 2 to 20.

- `limit=`: It must be followed by a number greater than 4.

For example, the command below creates a 10 x 8 board, where the largest number can be 4096:

```vim
:Start2048 rows=10 cols=8 limit=4096
```

## License

[MIT](https://github.com/jazielloureiro/2048/blob/master/LICENSE)
