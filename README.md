# Space Code Platform

REST API application made in Ruby that runs a platform that manages transactions, pilot's credits, contracts and resources.
The pilots can fly freely through the galaxy reaching the planets out to complete the contract and deliver resources to the destination planet as they spend some fuel.

- [Requirements](#requirements)
- [Installation](#installation)
- [How to use](#how-to-use)
- [Bonus](#bonus)
- [Run the tests](#run-the-tests)

## Requirements

- Docker
- Docker Compose

## Installation

Build the docker image:

```
docker-compose build
```

Run the app:

```
docker-compose run --service-ports app
```

This will open a random port in your system to be the entry-point for the API. Check it out with `docker ps` command. Eg. `0.0.0.0:32475`

If you want to specify a port you can use `APP_PORT` environment variable. Eg. `APP_PORT=3000 docker-compose run --service-ports app`
Then, you'll be able to access the root path with `0.0.0.0:3000` through your browser.

The `docker-compose run --service-ports app` is also responsible to setup the database and the initial data. So, Docker makes running the app easy.

## How to use

As an API, the interaction with the system is made hitting some endpoints. They are:

### List planets
#### Request
`GET /api/planets`

#### Response

```
HTTP/1.1 200 OK
Status: 200 OK
Content-Type: application/json

{
	"planets": [
		{
			"id": "bd664ba6-7791-11ee-8601-a8a1599ad2d2",
			"name": "Andvari",
			"created_at": "2023-10-31T02:05:58.321Z",
			"updated_at": "2023-10-31T02:05:58.321Z"
		},
		{
			"id": "d0107542-7791-11ee-862c-a8a1599ad2d2",
			"name": "Aqua",
			"created_at": "2023-10-31T02:05:58.333Z",
			"updated_at": "2023-10-31T02:05:58.333Z"
		},
		{
			"id": "d7430cc6-7791-11ee-a929-a8a1599ad2d2",
			"name": "Calas",
			"created_at": "2023-10-31T02:05:58.338Z",
			"updated_at": "2023-10-31T02:05:58.338Z"
		},
		{
			"id": "c94ff5f2-7791-11ee-b4ad-a8a1599ad2d2",
			"name": "Demeter",
			"created_at": "2023-10-31T02:05:58.328Z",
			"updated_at": "2023-10-31T02:05:58.328Z"
		}
	]
}
```

### Create pilot
#### Request
`POST /api/pilots`

Body:
```
{
	"pilot": {
		"name": "Bo Katan",
		"age": 31,
		"ship": {
			"name": "Any ship name",
			"fuel_capacity": 100,
			"fuel_level": 100,
			"weight_capacity": 50
		}
	}
}
```

#### Response
```
HTTP/1.1 201 Created
Status: 201 Created
Content-Type: application/json

{
	"pilot": {
		"id": "7168d32f-04cb-45e3-84e6-c634c6258d7c",
		"certification": "5616477",
		"name": "Bo Katan",
		"age": 31,
		"created_at": "2023-10-31T01:51:52.970Z",
		"updated_at": "2023-10-31T01:51:52.970Z",
		"planet_id": null,
		"ship": {
			"id": "a97c98eb-acbe-4c6d-9b52-0118b3809a77",
			"name": "Any ship name",
			"fuel_capacity": 100,
			"fuel_level": 100,
			"weight_capacity": 50,
			"pilot_id": "7168d32f-04cb-45e3-84e6-c634c6258d7c",
			"created_at": "2023-10-31T01:51:52.973Z",
			"updated_at": "2023-10-31T01:51:52.973Z"
		}
	}
}
```

### Create contract
#### Request
`POST /api/contracts`

Body
```
{
	"contract": {
		"description": "Deliver water, food and minerals to Aqua",
		"origin_planet_id": "bd664ba6-7791-11ee-8601-a8a1599ad2d2",
		"destination_planet_id": "d0107542-7791-11ee-862c-a8a1599ad2d2",
		"value": 20,
		"payload": [
			{
				"name": "water",
				"weight": 3
			},
			{
				"name": "food",
				"weight": 5
			},
			{
				"name": "minerals",
				"weight": 6
			}
		]
	}
}
```

#### Response
```
HTTP/1.1 201 Created
Status: 201 Created
Content-Type: application/json

{
	"contract": {
		"id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
		"description": "Deliver water, food and minerals to Aqua",
		"origin_planet_id": "bd664ba6-7791-11ee-8601-a8a1599ad2d2",
		"destination_planet_id": "d0107542-7791-11ee-862c-a8a1599ad2d2",
		"ship_id": null,
		"completed_at": null,
		"value": 20,
		"created_at": "2023-10-31T02:07:56.006Z",
		"updated_at": "2023-10-31T02:07:56.006Z",
		"payload": [
			{
				"id": "98c6744e-65ee-4d04-a05d-382689c75f4a",
				"name": "water",
				"weight": 3,
				"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
				"created_at": "2023-10-31T02:07:56.011Z",
				"updated_at": "2023-10-31T02:07:56.011Z"
			},
			{
				"id": "272133a4-4682-46d0-8d92-543fadba2c95",
				"name": "food",
				"weight": 5,
				"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
				"created_at": "2023-10-31T02:07:56.012Z",
				"updated_at": "2023-10-31T02:07:56.012Z"
			},
			{
				"id": "19b76921-ff46-41c9-9e7e-5e7216f03ef0",
				"name": "minerals",
				"weight": 6,
				"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
				"created_at": "2023-10-31T02:07:56.013Z",
				"updated_at": "2023-10-31T02:07:56.013Z"
			}
		]
	}
}
```


### Fly to the planet
#### Request
`POST /api/travels`

Body
```
{
	"travel": {
		"pilot_id": "e323a4c9-6d19-4b4d-805b-7eeeec9523e3",
		"planet_id": "bd664ba6-7791-11ee-8601-a8a1599ad2d2"
	}
}
```

#### Response
```
HTTP/1.1 204 No Content
Status: 204 No Content
Content-Type: application/json
```

### Accept contract
#### Request
`POST /api/contracts/:id/accept`

Body
```
{
	"contract": {
		"pilot_id": "e323a4c9-6d19-4b4d-805b-7eeeec9523e3"
	}
}
```

#### Response

```
HTTP/1.1 204 No Content
Status: 204 No Content
Content-Type: application/json
```

### List open contracts
#### Request
`GET /api/contracts`

#### Response

```
HTTP/1.1 200 OK
Status: 200 OK
Content-Type: application/json

{
	"contracts": [
		{
			"id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
			"description": "Deliver water, food and minerals to Aqua",
			"origin_planet_id": "bd664ba6-7791-11ee-8601-a8a1599ad2d2",
			"destination_planet_id": "d0107542-7791-11ee-862c-a8a1599ad2d2",
			"ship_id": "ab5a84ca-a2f4-4d3f-b830-3e30bce50930",
			"completed_at": null,
			"value": 20,
			"created_at": "2023-10-31T02:07:56.006Z",
			"updated_at": "2023-10-31T02:28:40.107Z",
			"payload": [
				{
					"id": "98c6744e-65ee-4d04-a05d-382689c75f4a",
					"name": "water",
					"weight": 3,
					"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
					"created_at": "2023-10-31T02:07:56.011Z",
					"updated_at": "2023-10-31T02:07:56.011Z"
				},
				{
					"id": "272133a4-4682-46d0-8d92-543fadba2c95",
					"name": "food",
					"weight": 5,
					"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
					"created_at": "2023-10-31T02:07:56.012Z",
					"updated_at": "2023-10-31T02:07:56.012Z"
				},
				{
					"id": "19b76921-ff46-41c9-9e7e-5e7216f03ef0",
					"name": "minerals",
					"weight": 6,
					"contract_id": "6b2381de-c0ec-4a28-814f-db4b3eafafaa",
					"created_at": "2023-10-31T02:07:56.013Z",
					"updated_at": "2023-10-31T02:07:56.013Z"
				}
			]
		}
	]
}
```


### Register a refill of the fuel
#### Request
`POST /api/fuel`

Body
```
{
	"fuel": {
		"pilot_id": "e323a4c9-6d19-4b4d-805b-7eeeec9523e3",
		"units": 2
	}
}
```

#### Response

```
HTTP/1.1 204 No Content
Status: 204 No Content
Content-Type: application/json
```

### Reports
#### Total weight in tons of each resource sent and received by each planet

#### Request
`GET /api/reports/total-weight-by-each-planet`

#### Percentage of resource type transported by each pilot
`GET /api/reports/total-weight-by-each-planet`

#### Intergalactic Federation transactions ledger sorted by date (oldest to newest)
`GET /api/reports/transaction-ledger`

## Bonus

There is a frontend for this app. You can access it by hitting the root path. All of its implementation is in `public` directory.

Unfortunately, the entire app is not covered by the frontend, but I did my best.

## Run the tests

```
docker-compose exec app bin/rails test
```

## License
MIT
