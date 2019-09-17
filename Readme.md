# AES VHDL



Ce dossier comprend un projet de déchiffrement de l’algorithme AES fonctionnelle en VHDL.

#### Structure :

Ce dossier comprends les fichiers sources avec les différents blocs de ce déchiffrement, les bench pour tester les fichiers sources, les librairies et le rapport final de ce projet.

#### Compiler le projet :

Ce projet doit être tester avec modelsim qu’il faut configurer avec les commandes suivantes:

```
source /soft/MENTOR/con􏰂g_bashrc/.bashrc_mentor
source /soft/MENTOR/con􏰂g_bashrc/.bashrc_modelsim
```

Puis lancer le build.sh et enfin lancer la simulation models avec la commande :

```
vsim &
```

Vous pouvez tester tous les bench pour tester les différents blocs. Le bloc final est **InvAES_tb.vhd**.