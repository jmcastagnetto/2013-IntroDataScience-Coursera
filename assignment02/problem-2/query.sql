(g) multiply.txt
select a.row_num, b.col_num, sum(a.value * b.value) from a,b
where a.col_num = b.row_num group by a.row_num, b.col_num;

0|0|10284
0|1|5221
0|2|990
0|3|1320
0|4|234
1|0|9825
1|1|2482
1|2|54
1|3|1269
1|4|1041
2|0|4198
2|1|735
2|2|3954
2|3|2874
3|0|9305
3|1|898
3|3|1881
3|4|201
4|0|3038
4|1|7152
4|4|4083
