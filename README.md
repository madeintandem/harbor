![Devmynd](https://www.devmynd.com/wp-content/uploads/2016/07/logo-horizontal.jpg "Devmynd")

# Harbor
Monitor your codeship builds from the comfort of a convenient OSX status bar application.

### System Requirements
Harbor supports Mac OSX 10.10 and greater. 

### Installation

If you don't have it already, install [brew cask](https://caskroom.github.io/), then run

```
$ brew cask install harbor
```

You can also download Harbor from the app store.

### Setup
Go to [Codeship] (http://www.codeship.io) (if you haven't already, you'll need to set up an account). Click on your profile picture. Under **My Account**, go to the **Account Settings** page. Copy your API Key. 

Click on the Harbor app and select **Set Preferences**. Paste your API key in the field labeled 'Codeship API Key'. Set the refresh rate (which is measured in seconds) and hit 'Save'. Your projects will be automatically fetched from Codeship. 

![Harbor Settings](https://www.devmynd.com/wp-content/uploads/2016/07/harbor_settings.jpg "Harbor Settings")

Click the Harbor icon from the menu bar. You will see a list of your Codeship Projects. Projects with a green Harbor icon are passing, while red means they are failing. A black Harbor icon means that a project is currently building. If you hover over a project you will see the your latest commits.

![Harbor Menu](https://www.devmynd.com/wp-content/uploads/2016/07/harbor_menu.jpg "Harbor Menu")

### License
Copyright (c) 2016 DevMynd Software.
