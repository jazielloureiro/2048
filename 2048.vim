function! s:main()
	call s:createBuffer()

	call setline(1, 'Hello World!')
	redraw
	call getchar()

	bdelete!
endfunction

function! s:createBuffer()
	if filewritable(expand('%'))
		write
	endif

	edit! 2048
endfunction

call s:main()
