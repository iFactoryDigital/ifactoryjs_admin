# EdenJS - Admin
[![TravisCI](https://travis-ci.com/eden-js/admin.svg?branch=master)](https://travis-ci.com/eden-js/admin)
[![Issues](https://img.shields.io/github/issues/eden-js/admin.svg)](https://github.com/eden-js/admin/issues)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/eden-js/admin)
[![Awesome](https://img.shields.io/badge/awesome-true-green.svg)](https://github.com/eden-js/admin)
[![Discord](https://img.shields.io/discord/583845970433933312.svg)](https://discord.gg/5u3f3up)

Administrator base logic component for [EdenJS](https://github.com/edenjs-cli)

`@edenjs/admin` creates all the base administrator logic that any normal system should require. This module also creates configuratble dashboards.

## Setup

### Install

```
npm i --save @edenjs/admin
```

### Configure

No configuration is required for this module

## Models

### `Dashboard` _[Usage](https://github.com/eden-js/admin/blob/master/bundles/dashboard/models/dashboard.js)_

Dashboard model consists of a single configurable dashboard instance. These are created in the frontend through the api.

#### Example

```js
// load model
const Dashboard = model('dashboard');

// get first dashboard
const dashboard = await Dashboard.findOne();

// dashboard used in frontend
const data = await dashboard.sanitise();
```

## Hooks

No hooks created in this module

## Views

### `<dashboard>` _[Usage](https://github.com/eden-js/admin/blob/master/bundles/dashboard/views/dashboard.tag)_

The dashboard view creates an instance of a dashboard container, this provides a fully configurable dashboard area.

#### Example

In the controller _[Usage](https://github.com/eden-js/admin/blob/master/bundles/admin/controllers/admin.js#L45)_

```jsx
// require helper
const blockHelper = helper('cms/block');

// get dashboards
const dashboards = await Dashboard.find();

// sanitise data
const data = await Promise.all(dashboards.map(dash => dash.sanitise()));

// render dashboard/home.tag view
res.render('dashboard/home', {
  blocks     : blockHelper.renderBlocks('admin'), // render blocks can be namespaced
  dashboards : data,
})
```

In the view `dashboard/home.tag` _[Usage](https://github.com/eden-js/admin/blob/master/bundles/admin/views/admin.tag#L6)_

```jsx
<dashboard-home-page>
  <dashboard dashboards={ opts.dashboards } blocks={ opts.blocks } type="my.dashboard" name="My Dashboard" />
</dashboard-home-page>
```