# 610. Triangle Judgement

## Approach

Use the triangle inequality theorem.

Three line segments can form a triangle only when:

- `x + y > z`
- `x + z > y`
- `y + z > x`

## SQL

```sql

select *,
    case
        when x+y > z 
        and x+z > y
        and y+z> x
        then 'Yes'
        else 'No'
        end as triangle
    from triangle


```
