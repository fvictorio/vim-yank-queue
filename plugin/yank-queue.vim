if exists("g:loaded_yank_queue") || &cp
  finish
endif
let g:loaded_yank_queue = 1

let g:yank_queue = []

function! s:yank_queue_add(type, ...)
  silent! call repeat#invalidate()

  let reg = s:save_reg('"')
  let reg_star = s:save_reg('*')
  let reg_plus = s:save_reg('+')
  let selection = &selection
  let &selection = 'inclusive'

  if a:type == 'line'
    silent execute "normal! '[V']y"
  else
    silent execute "normal! `[v`]y"
  endif

  let text = getreg('@')
  call add(g:yank_queue, text)

  call s:log_queue_size()

  let &selection = selection
  call s:restore_reg('"', reg)
  call s:restore_reg('*', reg_star)
  call s:restore_reg('+', reg_plus)
endfunction

function! s:yank_queue_put()
  if len(g:yank_queue) == 0
    echohl WarningMsg
    echom "No more elements in the yank queue"
    echohl None
    return
  endif

  silent! call repeat#set("\<Plug>(YankQueuePut)")
  let reg = s:save_reg('a')

  let @a = remove(g:yank_queue, 0)
  execute 'normal "ap'

  call s:log_queue_size()

  call s:restore_reg('a', reg)
endfunction

function! s:log_queue_size()
  let length = len(g:yank_queue)
  if (length == 1)
    echo 'There is 1 element in the yank queue'
  else
    echo 'There are ' . len(g:yank_queue) . ' elements in the yank queue'
  endif
endfunction

function! s:save_reg(name)
  try
    return [getreg(a:name), getregtype(a:name)]
  catch /.*/
    return ['', '']
  endtry
endfunction

function! s:restore_reg(name, reg)
  silent! call setreg(a:name, a:reg[0], a:reg[1])
endfunction

function! s:create_map(mode, lhs, rhs)
  if !hasmapto(a:rhs, a:mode)
    execute a:mode.'map '.a:lhs.' '.a:rhs
  endif
endfunction

nnoremap <silent> <expr> <Plug>(YankQueueAdd) ':<C-u>set operatorfunc=<SID>yank_queue_add<CR>'.(v:count1 == 1 ? '' : v:count1).'g@'
nnoremap <silent> <expr> <Plug>(YankQueueAddLine) ':<C-u>set operatorfunc=<SID>yank_queue_add<CR>'.(v:count1 == 1 ? '' : v:count1).'g@_'
nnoremap <silent> <Plug>(YankQueuePut) :<C-u>call <SID>yank_queue_put()<CR>

call s:create_map('n', 'yq', '<Plug>(YankQueueAdd)')
call s:create_map('n', 'yqq', '<Plug>(YankQueueAddLine)')
call s:create_map('n', 'yp', '<Plug>(YankQueuePut)')
