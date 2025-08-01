### To get task list

exec into a benchmark container (or any container for that matter) which is
running on the same network as the server in the android world container(s)
```zsh
docker exec -it android-benchmark-1 bash
```

open python
```zsh
python3
```

```python
import requests
res = requests.get("http://android-world-1:5001/suite/task_list?min_index=0&max_index=10")
print(res.text)
```


