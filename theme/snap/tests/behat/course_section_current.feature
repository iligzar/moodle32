# This file is part of Moodle - http://moodle.org/
#
# Moodle is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Moodle is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Moodle.  If not, see <http://www.gnu.org/licenses/>.
#
# Tests for toggle course section visibility in non edit mode in snap.
#
# @package    theme_snap
# @copyright  2016 Blackboard Inc. <www.blackboard.com>
# @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later


@theme @theme_snap
Feature: Entering a Snap course without specifying a section will take you to the current section

  Background:
    Given the following config values are set as admin:
      | theme | snap |
    And the following "courses" exist:
      | fullname | shortname | category | format |
      | Course 1 | C1        | 0        | topics |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | admin    | C1     | editingteacher |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |

  @javascript
  Scenario: Before a topic is highlighted, section 0 is the default
    Given I log in as "teacher1" (theme_snap)
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"

  @javascript
  Scenario: Once a topic is highlighted, that section is shown on entering the course
    Given I log in as "teacher1" (theme_snap)
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"
    And "#chapters li:nth-of-type(1).snap-visible-section" "css_element" should exist
    And I follow "Topic 1"
    And I follow "Highlight this topic as the current topic"
    And I am on the course main page for "C1"
    And I should see "Untitled Topic" in the ".section.state-visible" "css_element"
    And "#chapters li:nth-of-type(2).snap-visible-section" "css_element" should exist

  @javascript
  Scenario: If the teacher highlights a hidden section, the default section 0 is displayed
    Given I log in as "teacher1" (theme_snap)
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"
    And I follow "Topic 1"
    And I follow "Highlight this topic as the current topic"
    And I follow "Hide topic"
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"
    And I log out (theme_snap)
    And I log in as "student1" (theme_snap)
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"
    And I should see "Not available" in TOC item 1

  @javascript
  Scenario: Conditionally restricted section will not be shown on load, default to section 0
  Given I log in as "teacher1" (theme_snap)
    And I am on the course main page for "C1"
    And I go to course section 1
    And I follow "Highlight this topic as the current topic"
    And I restrict course section 1 by date to "tomorrow"
    And I should see "Conditional" in TOC item 1
    And I go to course section 1
    And I should see available from date of "tomorrow" in section 1
    And I log out (theme_snap)
    And I log in as "student1" (theme_snap)
    And I am on the course main page for "C1"
    Then I should see "Introduction" in the ".section.state-visible" "css_element"
    And I should see "Conditional" in TOC item 1


