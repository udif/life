life:
	iverilog top.v life_xc2c128.v life_cnt.v life_col.v life_cursor.v life_data_high.v life_data_low.v life_neighbour.v life_pipe.v life_row.v life_sum.v cap_touch.v
	vvp a.out -lxt2
wave:
	gtkwave
