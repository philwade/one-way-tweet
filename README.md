# One Way Tweet

### About:
One Way Tweet is a simple web based twitter client that only allows sending tweets. Why would you want that? If you like writing tweets but don't want
to get sucked into twitter every time you write one, like me. You can see it running at: [http://one-way-tweet.philwade.org] (http://one-way-tweet.philwade.org)
It's written with Elm, javascript and a node backend.


### Install:
```
npm install && cd dev-backend/ && npm install
```

### Serve locally:
```
npm start
```
* Access app at `http://localhost:8080/`

Backend is the same, just in the `dev-backend/` folder:
```
npm start
```

### Build & bundle for prod:
```
npm run build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`
* You also need to fill in the `secrets.json` file in `dev-backend`
