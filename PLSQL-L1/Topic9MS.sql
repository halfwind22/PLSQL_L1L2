/*Assignment 1:*/
/*A*/
select * from all_objects where object_type IN('FUNCTION','PROCEDURE') and Owner = 'HR';

/*B*/
select name,line,text from all_source where Owner = 'HR' and type='PROCEDURE' 
and name='ADD_JOB_HISTORY'
order by line;

/*C*/
select * from user_errors;