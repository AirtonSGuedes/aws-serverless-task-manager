import json
import boto3
import uuid
import os
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }

def lambda_handler(event, context):

    method = event["requestContext"]["http"]["method"]

    if method == "POST":

        body = json.loads(event["body"])

        task = {
            "taskId": str(uuid.uuid4()),
            "title": body["title"],
            "status": "PENDING",
            "createdAt": datetime.utcnow().isoformat()
        }

        table.put_item(Item=task)

        return response(201, task)

    if method == "GET":

        result = table.scan()

        return response(200, result["Items"])
    if method == "DELETE":
        path_params = event.get("pathParameters") or {}
        task_id = path_params.get("id")

        if not task_id:
            return response(400, {"message": "id é obrigatório"})

        table.delete_item(
            Key={
             "taskId": task_id
         }
        )

        return response(200, {"message": "Tarefa deletada", "taskId": task_id})
    return response(400, {"message": "unsupported method"})