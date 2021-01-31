## ClamAV API

[![GitHub](https://img.shields.io/badge/GitHub-romarcablao-lightgrey)](https://github.com/romarcablao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-romarcablao-blue)](https://linkedin.com/in/romarcablao)

### Sample Response

1. 200 Success

```json
{
  "success": true,
  "data": {
    "result": [
      {
        "name": "sample.txt",
        "is_infected": false,
        "viruses": []
      },
      {
        "name": "eicar.com",
        "is_infected": true,
        "viruses": ["Eicar-Signature"]
      },
      {
        "name": "xrat.txt",
        "is_infected": true,
        "viruses": ["Doc.Dropper.Agent-6761844-0"]
      }
    ]
  }
}
```

2. 400 Bad Request

```json
{
  "success": false,
  "data": {
    "error": "Too much files uploaded."
  }
}
```

3. 403 Forbidden

```json
{
  "success": false,
  "data": {
    "error": "Invalid credentials!"
  }
}
```

4. 413 Payload Too Large

```json
{
  "success": false,
  "data": {
    "error": "File size limit exceeded."
  }
}
```
