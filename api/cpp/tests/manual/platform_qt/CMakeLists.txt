# Copyright © SixtyFPS GmbH <info@slint.dev>
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Slint-Royalty-free-1.0 OR LicenseRef-Slint-commercial

add_executable(platform_qt main.cpp)
target_link_libraries(platform_qt PRIVATE Slint::Slint Qt::Gui Qt::Widgets Qt::GuiPrivate)
slint_target_sources(platform_qt appwindow.slint)

