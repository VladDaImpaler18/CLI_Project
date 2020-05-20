## National Park Service Park Finder

I created a program that connects to www.nps.gov to provide the user with all the National Park sites in the state of their choice. Once they pick a state the program lists all the sites in the respective state.

# Getting Started

Clone the repository from github. Obtrain a free API key by registering for one on (NPS's website.)[https://www.nps.gov/subjects/developer/get-started.htm] With the API key obtain create an `.env file` and for the first line put the following, `MY_NPS_KEY="Your API Key"`, with your API key in the appropriate field, *without quotes*. With an API key, install the required gem bundles and the following gems `:httparty`, `json`, `dotenv`. Once all the prerequisites are completed start the program by maneuvering to the project directly CLI_Project/, and entering the command `bin/execute`.

# Prerequisites
Ruby will need to be installed, along with the required gems listed above.

# Version
Version 1.1

# Authors
Vladimir Jimenez

# License
(c) 2020 Vladimir Jimenez, all rights reserved
For Online Software Engineering PT - CLI Project

# Acknowledgments
I would like to thank the teacher of Software Engineering Online PT-032320 for preparing me for this project. Additional thanks goes to Duckduckgo.com, and Stack Overflow.

# Changelog
Version 1.1 (5/20/2020) Expanded functionality to allow user to pick a different state without having to reload program.
Version 1.0 (5/14/2020) Initial release