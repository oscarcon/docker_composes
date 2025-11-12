SET SESSION spill_enabled = true;
select * from sf1000.lineitem l join sf1000.orders using (orderkey) limit 10;

