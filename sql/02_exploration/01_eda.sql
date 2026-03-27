select type, count(*)
from transactions
group by type
order by type;