# Directions for using arc and arc_ecto for local upload to Phoenix

```
mix phx.new app
cd app
mix ecto.create
```


Edit mix.exs

```
	{:arc, "~> 0.8.0"},
	{:arc_ecto, "~> 0.7.0"},
	{:poison, "~> 3.1"}

mix deps.get
```



Edit config.exs
```
	config :arc,
	  storage: Arc.Storage.Local
```


Run to create an uploader.

```
	mix arc.g image_file
```


Need to move this for Phoenix 1.3
```
	mv web/uploaders lib/app_web/uploaders
```


Edit image_file.ex in lib/app_web/uploaders/image_file.ex
```
  use Arc.Ecto.Definition
```


Prep the Phoenix app for the uploader

```
mix phx.gen.html Assets Image images name:string filename:string

```

Add to router.ex
```
    resources "/images", ImageController
```

Run 
```
	mix ecto.migrate
```


Make this Image model work together with the uploader we just created.

Edit app/lib/app/assets/image.ex and add

```
	use Arc.Ecto.Schema
```

Change the type of the :filename field to the uploader with App.ImageFile.Type as in
```
	field :filename, App.ImageFile.Type
```

In the changeset, cast the :filename field to an attachments.
```
    |> cast_attachments(attrs, [:filename])
```


Edit the image templates to enable file uploads

Edit form.html.eex to enable multipart true

```
	<%= form_for @changeset, @action, [{:multipart, true}], fn f -> %>
```

Change the :filename input field to use file_input instead of text_input:
Eg replace text_input against file_input type.



Edit index.html.eex

Remove any references to @image.filename in app/lib/app_web/templates/image/index.html.eex
```
	<td><%= # image.filename %></td>
```

Do the same in app/lib/app_web/templates/image/view.html.eex



Run
```
	mix.ecto.migrate
	mix phx.server
```

Access this page and try to upload an image:
http://localhost:4000/images

Test query via iex -S mix:
```
 	App.Assets.list_images
	App.Assets.get_image!(1)
```

Edit index.html.eex

First, reference the schema file for the appropriate namespace, which will be:
App.ImageFile

To display image, edit index.html.eex in images template folder
```
 	<td><img height=100 width=auto src="<%= App.ImageFile.url({image.filename, image})%>"></td>
```

Edit show.html
```
 	<img height=100 width=auto src="<%=  App.ImageFile.url({@image.filename, @image})%>"
```


Put this in either router.ex or app.ex (?)

```
defimpl Phoenix.HTML.Safe, for: Map do
  def to_iodata(data), do: data |> Poison.encode! |> Plug.HTML.html_escape
end
```

This is why we added {:poison, "~> 3.1"} to mix.exs

This is related to this issue, 
"Phoenix.HTML.Safe not implemented for %{}""
https://github.com/phoenixframework/phoenix/issues/1908


Edit endpoint to allow Phoenix to serve images from /uploads directory.

```
plug Plug.Static, 
  at: "/uploads", from: Path.expand('./uploads'), gzip: false
```

