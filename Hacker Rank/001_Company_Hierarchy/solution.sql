/*
    query to print company_code, founder name, total #lead managers,
    total #senior managers, #total managers, #employees, 
    order by company_code asc
    
    table would have duplicate records, 
    company code has string c_1, c_2, c_10 so the asc would be
    c_1, c_10, etc
*/
select 
    c.company_code, c.founder, 
    count(distinct e.lead_manager_code) as total_leadManagers,
    count(distinct e.senior_manager_code) as total_seniorManagers, 
    count(distinct e.manager_code) as total_managers, 
    count(distinct e.employee_code) as total_employee   
    
from 
    company c
    left join employee e
    on c.company_code = e.company_code
group by c.company_code, c.founder
order by c.company_code asc