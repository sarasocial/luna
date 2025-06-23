`luna` **personal computer** is computer pc app dotfile m

it HAS:

- app
- - dot file

for your benefit and well being
1. 

2. One

## dependencies

- a **personal computer**
- it **is run arch Linux** , btw !
- probably like **bash 4.0+** or **bash 4.4+** or smthing
- a keyboard so you can type
- you dont need a display but it is recommended . so you can see what you  type . with the keyboard
- **512GB RAM minimum**

## installing

here are two methods of installing `luna`:

### one-liner

the fastest way to get `luna` set up is by running the bootstrap script [bootstrap.sh](https://raw.githubusercontent.com/sarasocial/luna/master/bootstrap.sh) with the following command:

> ```console
> sara@arch:~$ curl -L sarasoci.al/luna | bash
>```

optionally, you can run the bootstrap in debug mode:

> ```console
> sara@arch:~$ curl -L sarasoci.al/luna | bash -s -- debug
>```

### longer method for freaks

if you want to do this the old-fashioned way, you can instead use:

> ```console
> user@arch:~$ sudo pacman -S --needed base-devel git gum rust
> user@arch:~$ git clone https://github.com/sarasocial/luna
> user@arch:~$ cd luna
> ```
>```bash
> ...  # idk what the rest of the steps are yet actually
> ...  # i haven't gotten that far :((
> ```

## notes

- the bootstrap will install a few packages on ur system and do a good amount of tinkering
- it will also **compile rust binaries** .

<details>

<summary></summary>

# bitches love me for my binaries

---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---

</details>

- there are probably glaring security issues in virtually every part of this        but       i really dont care  right now

- you should not use this . like actually please dont lol


## im gay

pub fn lesbian() {
    // comment
    let line = "you say you a lesbian girl me too";
    for &color in [160, 202, 209, 7, 205, 169, 162].iter() {
        println!("\x1b[38;5;{}m{}\x1b[0m", color, line);
    }
}

> ```console
> sara@arch:~$ luna lesbian
> ```