(a) select.txt
select * from frequency where docid='10398_txt_earn'
select count(*) from frequency where docid='10398_txt_earn'

(b) select_project.txt
select count(*) from frequency where docid='10398_txt_earn' and count=1

(c) union.txt
select count(distinct term) from frequency 
where docid in ('10398_txt_earn', '925_txt_trade') and count=1

(d) count.txt
select count(*) from frequency where term='parliament'

(e) big_documents.txt
select docid, sum(count) from frequency group by docid having sum(count) > 300

(f) two_words.txt
select distinct docid from frequency where term='world' 
and docid in (select distinct docid from frequency where term='transactions')
