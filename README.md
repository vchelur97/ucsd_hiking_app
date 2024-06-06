# README

This is a Ruby on Rails application for the UCSD Hiking Club. Here are the steps to get the application up and running.

## Configuration

Configuration settings are stored in the [`.env`](.env) file. You can use the [`.env.template`](.env.template) as a starting point. You will have to use the same [`master.key`](config/master.key) file as the production environment to decrypt the credentials. Please contact the project maintainers for the values of the environment variables.

## Development Environment with DevContainers

This project uses DevContainers to standardize the development environment across different machines and developers. This helps to ensure that everyone is working with the same tool versions, reducing the "it works on my machine" problem. More details can be found in the [`.devcontainer/README.md`](.devcontainer/README.md) file.


## Database creation

Once you have the devcontainer running, you can setup the database by running:

```sh
bin/rails db:create
bin/rails db:migrate
```

## Running the application

You can start the Rails server by running:

```sh
bin/dev
```

This will start the Rails server on port 3000. You can access the application at [http://localhost:3000](http://localhost:3000).
