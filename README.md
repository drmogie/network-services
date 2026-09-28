# Network Services

[![Add repository to my Home Assistant][repo-badge]][repo-url]
![Version](https://img.shields.io/badge/version-2026.09.28.03-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Home Assistant add-on repository for network services.

## Add-ons

- **Technitium DNS** (`technitium_dns`): runs the official
  [Technitium DNS Server](https://technitium.com/dns/) inside Home Assistant.

## Install

1. Click the badge above, or in Home Assistant go to
   Settings, Add-ons, Add-on Store, three-dot menu, Repositories.
2. Add this URL: `https://github.com/drmogie/network-services`
3. Install **Technitium DNS**.
4. Start it and open `http://<your-ha-ip>:5380`.

See [technitium_dns/DOCS.md](technitium_dns/DOCS.md) for all options.

## Credits

Technitium DNS Server is made by
[Technitium](https://github.com/TechnitiumSoftware/DnsServer).
This project only wraps the official Docker image.
The Technitium logo belongs to Technitium. It is used here only to
show which software the add-on runs.

## License

MIT. See [LICENSE](LICENSE).

[repo-badge]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[repo-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdrmogie%2Fnetwork-services
