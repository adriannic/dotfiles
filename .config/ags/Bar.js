import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { Workspaces } from "./Workspaces.js";
import { Clock } from "./Clock.js";
import { LogoButton } from "./LogoButton.js";

const StartWidgets = ({ monitor }) =>
  Widget.Box({
    spacing: 4,
    hpack: "start",
    vpack: "end",
    children: [
      LogoButton(),
      Workspaces({ monitor }),
    ],
  });

const CenterWidgets = () => Widget.Box({});

const EndWidgets = () =>
  Widget.Box({
    hpack: "end",
    vpack: "end",
    children: [
      Clock(),
    ],
  });

export const Bar = ({ monitor } = {}) =>
  Widget.Window({
    className: "barWindow",
    name: `bar-${monitor}`,
    monitor,
    anchor: ["left", "bottom", "right"],
    exclusive: false,
    margins: [-36, 0],
    child: Widget.CenterBox({
      className: "bar",
      startWidget: StartWidgets({ monitor }),
      centerWidget: CenterWidgets(),
      endWidget: EndWidgets(),
    }),
  });

export const Spacer = ({ monitor }) =>
  Widget.Window({
    name: `spacer-${monitor}`,
    monitor,
    anchor: ["left", "bottom", "right"],
    layer: "bottom",
    exclusive: true,
    child: Widget.Label({ label: "", css: "min-height: 36px;" }),
  });