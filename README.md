# vim-yank-queue

Yank pieces of text and paste them in the same order in which you copied them.

## Example

Let's say you have something like this:

```
key 1:
key 2:
another key:
not easy to use visual block here:

copy_me
me_too
not_me
yes_me
me_too_please
```

And you want to copy the values below after each key (except the middle one).
You can do it one by one, or you can use some contrived macro. This plugin
lets you do it like this:

![vim-yank-queue demo](/img/demo.gif)

## Installation

Use one of the hundred of methods that exist to install a vim plugin. I recommend [vim-plug](https://github.com/junegunn/vim-plug):

```
Plug 'fvictorio/vim-yank-queue'
```

## Mappings

The plugin adds these mappings:

- `yq`: Yank text and insert it into the queue. For example `yqiw` will insert
  the word under the cursor, and `yqq` will insert the whole line.
- `yp`: Paste the first element of the queue (i.e. the first one you copied) and
  remove it.

Both of them support [repeat.vim](https://github.com/tpope/vim-repeat).

## To-do

- Add option to disable mappings
- Add support for yanking in visual mode
- Add command for pasting the whole queue (maybe with a given separator?)
