test:
	nix eval -f . > new.nix
	nix eval -f answers.nix > old.nix
	diff new.nix old.nix
	rm -f new.nix old.nix
