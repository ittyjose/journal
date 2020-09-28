### OTP Service 

Setup environment variable `SMS_API_KEY` with the `AppKey` of the OTP service. Then OTP sending and 
verification APIs will work.

If this key is not present then no SMS will be sent. But in `development` mode you can use the OTP `1947` for testing. 

## Admin

### Login

```
curl                                       \
     -X POST                                 \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     -d '{"username": "root", "password": "whoami"}' \
     http://localhost:3000/api/v1/admin/sessions
```

```
Status: 200

{
  auth_token: "aYrUiKbHeFeMnKwUgJUB5Q=="
}
```
OR

```
Status: 401
```

### Visits Filter 

```
curl                                        \
     -H "X-Auth-Token: L7c99MyS9rX8jwxcbuRN"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/admin/visits?visitable_id=8fa1033f-b8a1-4cc1-a00b-378eae56d790&visitable_type=Merchant&from=2020-07-05&to=2020-07-17
```

```
{
  "visits": [
    {
      "entry_at":"2020-07-07T15:20:43.543+05:30",
      "name":"Stephen Nedumpally",
      "phone":"2255225522",
      "age":45
    }
  ]
}
```

Note: 

1. `visitable_id` and `visitable_type` are mandatory parameters. They should come from scanning the QR code. If they are missing the backend will respond with `400`
2. `from` and `to` are optional. They have default values set to `7-days-ago` and `today`.

### Search for a user

```
curl                                        \
     -H "X-Auth-Token: aYrUiKbHeFeMnKwUgJUB5Q=="  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/admin/users?phone=1234567890&age=34
```

```
{
  users: [
    {id: 10},
    {id: 20}
  ]
}
```

Note: 

1. Practically, this API response should only return a maximum of 1 user.
2. `age` and `phone` are mandatory parameters. If they are missing the backend will respond with `400`.

### RouteMap for a user

```
curl                                        \
     -H "X-Auth-Token: L7c99MyS9rX8jwxcbuRN"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/admin/users/:user_id/route_map?from=2020-07-02&to=2020-07-17
```

```
{
  user: {
    name: "Abram Qureshi"
  },
  visits: [
    {
      entry_at: "10:10:00 22-05-2020",
      exit_at: "11:00:00 22-05-2020",
      visitable: {
        type: "Merchant",
        id: "dsfgdfgfd",
        name: "Lakeshore Hospital",
        phone: "1233214567",
        address: "Madavana, Maradu PO, 682023"
      }
   }
  ]
}
```

---

## Visits

### Log a new visit

```
curl                                       \
     -X POST                                 \
     -H "X-Auth-Token: pFfxLhBgvnoYeXnbDnFL" \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     -d '{"visitable_id":"3sds324234", "visitable_type": "Merchant"}' \
     http://localhost:3000/api/v1/visits
```

### Get all visits of a user (most recent one first)

```
curl                                        \
     -H "X-Auth-Token: pFfxLhBgvnoYeXnbDnFL"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/visits
```

### Get ongoing visits of a user (most recent one first)

```
curl                                        \
     -H "X-Auth-Token: pFfxLhBgvnoYeXnbDnFL"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/visits/ongoing
```

### Mark exit on an ongoing visit

```
curl                                       \
     -X PUT                                 \
     -H "X-Auth-Token: pFfxLhBgvnoYeXnbDnFL" \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     -d '{"visitable_id":"3sds324234", "visitable_type": "Merchant"}' \
     http://localhost:3000/api/v1/visits/:visit_id/exit
```


### User Login 

1. Creates a new user if phone number doesn't already exist.
2. Updates the existing user with given Name and DOB if phone number already exists.
3. Sends out an OTP to the user's phone number.

```
curl                                        \
     -X POST                                  \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     -d '{"user":{"name":"Jacky", "date_of_birth": "1985-05-03", "phone_number": "2255"}}'            \
     http://localhost:3000/api/v1/sessions
```

### User OTP Verification

Note: In development mode you can use `1947` as the OTP and it will work always.

```
curl                                       \
     -X POST                                  \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     http://localhost:3000/api/v1/users/:user_id/verify_otp?otp=1947
```

If OTP is incorrect response will be a `400`

Otherwise:
```
{
  "id": 45, 
  "name": "Gudrun Ziemann", 
  "phone_number": "1243444037", 
  "date_of_birth": "1956-09-12"
}
```

### Create a Merchant

1. Creates a new merchant if phone number doesn't already exist.
2. Updates the existing merchant with given details if phone number already exists.
3. Sends out an OTP to the merchant's phone number.

```
curl                                       \
     -X POST                                  \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     -d '{"merchant":{"name":"Lakeshore Hospital", "phone_number": "2255", "address": "NH44, Madavana, Maradu", "lb_code": "M071100"}}
     http://localhost:3000/api/v1/merchants
```

Response 

```
{
  "temp_id": "1166xx2"
}
```

### Merchant OTP Verification

Note: In development mode you can use `1947` as the OTP and it will work always.

```
curl                                       \
     -X POST                                  \
     -H "Accept: application/json"           \
     -H "Content-type: application/json"     \
     http://localhost:3000/api/v1/merchants/:temp_id/verify_otp?otp=1947
```

If OTP is incorrect response will be a `400`

Otherwise:

```
{
  "id": "51081d11", 
  "name": "Lakeshore Hospital", 
  "phone_number": "9090909090", 
  "address": "NH44, Madavana, Maradu", 
  "lb_code": "M071100",
  "district_name": "Ernakulam District ",
  "lb_name_english": "Maradu",
  "lb_name_full": "Maradu Muncipality, Ernakulam District "
}
```

### Merchants Filter 

```
curl                                        \
     -H "X-Auth-Token: L7c99MyS9rX8jwxcbuRN"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/admin/merchants?district_id=13
```

OR 

```
curl                                        \
     -H "X-Auth-Token: L7c99MyS9rX8jwxcbuRN"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/admin/merchants?lb_code=LB12345
```

Response 

```
{
  "merchants": [
    {
      "id": "51081d11", 
      "name": "Lakeshore Hospital", 
      "phone_number": "9090909090", 
      "address": "NH44, Madavana, Maradu", 
      "lb_code": "LB12345",
      "district_name": "Ernakulam District ",
      "lb_name_english": "Maradu",
      "lb_name_full": "Maradu Muncipality, Ernakulam District "
    }
  ]
}
```

Note: 

1. `district_id` OR `lb_code` is a mandatory parameter. One of them should be present. If it  is missing the backend will respond with `400`

### Local Bodies

```
curl                                        \
     -H "X-Auth-Token: L7c99MyS9rX8jwxcbuRN"  \
     -H "Accept: application/json"            \
     -H "Content-type: application/json"      \
     http://localhost:3000/api/v1/local_bodies
```

Response

```
{
  "districts": {
      "8": "Thrissur District ", 
      "13": "Kannur District "},
      "1": "Thiruvananthapuram District",
      "6": "Idukki District ",
      ...
  },

  "data": {
    "8": {
      "types": ["Muncipality", "Block Panchayat", "Grama Panchayat"]
      "data": {
        "Muncipality": [{"lb_name_english": "Kattappana", "lb_code": "M060200"}...], 
        "Block Panchayat": [{"lb_name_english":"Adimaly", "lb_code":"B060100"}...],
        "Grama Pachayat": [{"lb_name_english":"Peerumedu", "lb_code":"G060804"}...]
      }
    },
    ...
  }
}

Note: 

- First select the district
- Based on the district display the types of local bodies in that district.
- Based on the type of the local body, display the list of local bodies in the district.
- Based on the selected local body, get the `lb_code` which is the is the identifier for a local body.

```
