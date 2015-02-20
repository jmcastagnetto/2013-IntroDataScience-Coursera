(h) similarity_matrix.txt
select a.docid as a_docid, b.docid as b_docid, sum(a.count * b.count)
from Frequency as a, Frequency as b
where a.term = b.term and a.docid='10080_txt_crude' and b.docid='17035_txt_earn';

* For a similarity matrix of all documents

select a.docid as a_docid, b.docid as b_docid, sum(a.count * b.count)
from Frequency as a, Frequency as b
where a.term = b.term and a.docid < b.docid;

(i) keyword_search.txt

select a.docid as a_docid, b.docid as b_docid, sum(a.count * b.count) as product
from (
select 'q' as docid, 'washington' as term, 1 as count
union
select 'q' as docid, 'taxes' as term, 1 as count
union
select 'q' as docid, 'treasury' as term, 1 as count
) as a, Frequency as b
where a.term = b.term
group by a.docid, b.docid
order by product desc;

* View

CREATE VIEW "main"."queryview" AS 
select * from Frequency
union
select 'q' as docid, 'washington' as term, 1 as count                           
union                                                                           
select 'q' as docid, 'taxes' as term, 1 as count                                
union                                                                           
select 'q' as docid, 'treasury' as term, 1 as count ;

* Query

select b.docid as docid, sum(a.count * b.count) as product
from queryview as a, queryview as b                                             
where a.term = b.term and a.docid='q' and b.docid != 'q'
group by a.docid, b.docid                                                       
order by product desc, docid asc;
