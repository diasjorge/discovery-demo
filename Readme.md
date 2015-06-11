This is the demo I used on my talk "The rise of containers"

To run the demo.

Install virtual box.

Then we need to prepare our base image.

```
cd base; vagrant up; vagrant package
```

Once it finishes, from the root of the project.

```
./demo.sh
```