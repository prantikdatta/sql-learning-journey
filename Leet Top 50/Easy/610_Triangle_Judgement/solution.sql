-- LeetCode 610. Triangle Judgement


select *,
    case
        when x+y > z 
        and x+z > y
        and y+z> x
        then 'Yes'
        else 'No'
        end as triangle
    from triangle
