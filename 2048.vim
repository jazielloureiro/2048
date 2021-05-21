function! s:main()
	call s:createBuffer()

	let l:game = s:createGameDict()

	call s:drawBoardStructure(l:game.rows, l:game.cols)

	while l:game.input != "q" && l:game.available_squares > 0 && !s:is2048Reached(l:game.board)
		call s:drawBoard(l:game.board)

		let l:game.input = nr2char(getchar())

		if l:game.input == "h"
			call s:mergeNumbers(l:game, {
				\ "range_rows": range(4),
				\ "range_cols": range(3),
				\ "increment": 1,
				\ "limit": 3
				\ })

			call s:move(l:game, {
				\ "range_rows": range(4),
				\ "range_cols": range(1, 3),
				\ "increment": -1,
				\ "limit": 1
				\ })
		elseif l:game.input == "j"
			call s:mergeNumbers(l:game, {
				\ "range_rows": range(3, 1, -1),
				\ "range_cols": range(4),
				\ "increment": -1,
				\ "limit": 0
				\ })

			call s:move(l:game, {
				\ "range_rows": range(2, 0, -1),
				\ "range_cols": range(4),
				\ "increment": 1,
				\ "limit": 2
				\ })
		elseif l:game.input == "k"
			call s:mergeNumbers(l:game, {
				\ "range_rows": range(3),
				\ "range_cols": range(4),
				\ "increment": 1,
				\ "limit": 3
				\ })

			call s:move(l:game, {
				\ "range_rows": range(1, 3),
				\ "range_cols": range(4),
				\ "increment": -1,
				\ "limit": 1
				\ })
		elseif l:game.input == "l"
			call s:mergeNumbers(l:game, {
				\ "range_rows": range(4),
				\ "range_cols": range(3, 1, -1),
				\ "increment": -1,
				\ "limit": 0
				\ })

			call s:move(l:game, {
				\ "range_rows": range(4),
				\ "range_cols": range(2, 0, -1),
				\ "increment": 1,
				\ "limit": 2
				\ })
		endif

		if l:game.is_move
			call s:addNumberToBoard(l:game)
			let l:game.is_move = 0
		endif
	endwhile

	bdelete!
endfunction

function! s:createBuffer()
	if filewritable(expand('%'))
		write
	endif

	edit! 2048
endfunction

function! s:createGameDict()
	let l:game = #{rows: 4, cols: 4, is_move: 0, input: ""}

	let l:game.board = s:createBoard(l:game.rows, l:game.cols)

	let l:game.available_squares = l:game.rows * l:game.cols

	call s:addNumberToBoard(l:game)
	call s:addNumberToBoard(l:game)

	return l:game
endfunction

function! s:createBoard(rows, cols)
	let l:cols = []
	for l:i in range(a:cols)
		let l:cols += [0]
	endfor

	let l:board = []
	for l:i in range(a:rows)
		let l:board += [[]]
		let l:board[l:i] = copy(l:cols)
	endfor

	return l:board
endfunction

function! s:addNumberToBoard(game)
	let l:position = rand() % a:game.available_squares + 1
	let l:pos_count = 0

	for l:i in range(a:game.rows)
		for l:j in range(a:game.cols)
			if a:game.board[l:i][l:j] == 0
				let l:pos_count += 1

				if l:pos_count == l:position
					let a:game.board[l:i][l:j] = rand() % 10 == 0? 4 : 2
					let a:game.available_squares -= 1
					return
				endif
			endif
		endfor
	endfor
endfunction

function! s:drawBoardStructure(rows, cols)
	call s:drawLine(
		\ #{id: 1, cols: a:cols, start: "╔", mid: "╦", end: "╗"}
		\ )

	for l:i in range(2, a:rows * 2)
		if l:i % 2 == 0
			call setline(l:i, "")
		else
			call s:drawLine(
				\ #{id: l:i, cols: a:cols,
				\   start: "╠", mid: "╬", end: "╣"}
				\ )
		endif
	endfor

	call s:drawLine(
		\ #{id: a:rows * 2 + 1, cols: a:cols,
		\   start: "╚", mid: "╩", end: "╝"}
		\ )
endfunction

function! s:drawLine(line)
	let l:aux = a:line.start

	for l:i in range(a:line.cols - 1)
		let l:aux .= "══════" . a:line.mid
	endfor

	let l:aux .= "══════" . a:line.end

	call setline(a:line.id, l:aux)
endfunction

function! s:drawBoard(board)
	for [l:i, l:j] in [[0, 2], [1, 4], [2, 6], [3, 8]]
		let l:line = "║ "

		for l:k in range(4)
			if a:board[l:i][l:k] != 0
				let l:line .= printf("%4d", a:board[l:i][l:k]) . " ║ "
			else
				let l:line .= "    " . " ║ "
			endif
		endfor

		call setline(l:j, l:line)
	endfor

	redraw
endfunction

function! s:is2048Reached(board)
	for l:i in a:board
		for l:j in l:i
			if l:j == 2048
				return 1
			endif
		endfor
	endfor

	return 0
endfunction

function! s:mergeNumbers(game, op)
	for l:i in a:op.range_rows
		for l:j in a:op.range_cols
			if a:game.board[l:i][l:j] != 0 && a:game.input =~ 'h\|l'
				for l:k in range(l:j + a:op.increment, a:op.limit, a:op.increment)
					if a:game.board[l:i][l:j] == a:game.board[l:i][l:k]
						let a:game.board[l:i][l:j] *= 2
						let a:game.board[l:i][l:k] = 0
						let a:game.available_squares += 1
						let a:game.is_move = 1
						break
					elseif a:game.board[l:i][l:k] != 0
						break
					endif
				endfor
			elseif a:game.board[l:i][l:j] != 0
				for l:k in range(l:i + a:op.increment, a:op.limit, a:op.increment)
					if a:game.board[l:i][l:j] == a:game.board[l:k][l:j]
						let a:game.board[l:i][l:j] *= 2
						let a:game.board[l:k][l:j] = 0
						let a:game.available_squares += 1
						let a:game.is_move = 1
						break
					elseif a:game.board[l:k][l:j] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor
endfunction

function! s:move(game, op)
	for l:i in a:op.range_rows
		for l:j in a:op.range_cols
			if a:game.board[l:i][l:j] != 0 && a:game.input =~ 'h\|l'
				for l:k in range(l:j, a:op.limit, a:op.increment)
					if a:game.board[l:i][l:k + a:op.increment] == 0
						let l:aux = a:game.board[l:i][l:k]
						let a:game.board[l:i][l:k] = a:game.board[l:i][l:k + a:op.increment]
						let a:game.board[l:i][l:k + a:op.increment] = l:aux
						let a:game.is_move = 1
					else
						break
					endif
				endfor
			elseif a:game.board[l:i][l:j] != 0
				for l:k in range(l:i, a:op.limit, a:op.increment)
					if a:game.board[l:k + a:op.increment][l:j] == 0
						let l:aux = a:game.board[l:k][l:j]
						let a:game.board[l:k][l:j] = a:game.board[l:k + a:op.increment][l:j]
						let a:game.board[l:k + a:op.increment][l:j] = l:aux
						let a:game.is_move = 1
					else
						break
					endif
				endfor
			endif
		endfor
	endfor
endfunction

call s:main()
