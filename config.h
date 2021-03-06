/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define APPLICATION_NAME @"appfirst"
#define DEFAULT_USER_NAME_KEY @"AppFirstDefaultUserName"

#define SERVER_KEY_NAME @"Server"
#define DB_KEY_NAME @"pk"
#define DATA_NAME @"data"
#define OS_TYPE_NAME @"OS"

#define CPU_RESOURCE_NAME @"cpu"
#define MEMORY_RESOURCE_NAME @"mem"
#define DISK_RESOURCE_NAME @"disk"


#define RESOURCE_VALUE_NAME @"values"
#define RESOURCE_TOTAL_NAME @"total"
#define RESOURCE_NAME_NAME @"names"
#define RESOURCE_TIME_NAME @"time"

#define ALERT_TYPE_NAME @"Type"
#define ALERT_STATUS_NAME @"Enabled"
#define ALERT_TARGET_NAME @"Target"
#define AlERT_LAST_TRIGGER_NAME @"Last Triggered"
#define ALERT_TRIGGER_TYPE_NAME @"Trigger"
#define ALERT_NAME @"Name"
#define ALERT_VALUE_NAME @"Value"
#define ALERT_RESET_NAME @"Reset"
#define ALERT_RECIPIENTS_NAME @"Recipients"

#define AF_BAR_WIDTH 160.0
#define AF_BAR_HEIGHT 12.0

#define AF_VERTICAL_BAR_HEIGHT 60.0
#define AF_VERTICAL_BAR_WIDTH 20.0

#define AF_LEGEND_HEIGHT 10.0
#define AF_LEGEND_WIDTH 10.0

#define IPAD_SCREEN_WIDTH 768
#define IPAD_SCREEN_HEIGHT 1024
#define IPAD_LOADER_SIZE 40
#define IPAD_NAVIGATION_TITLE_WIDTH 400
#define IPAD_NAVIGATION_TITLE_HEIGHT 40
#define IPAD_TITLE_BIG_FONTSIZE 25
#define IPAD_TABLE_CELL_BIG_FONTSIZE 14
#define IPAD_TABLE_CELL_NORMAL_FONTSIZE 12
#define IPAD_TITLE_NORMAL_FONTSIZE 11
#define IPAD_TEXT_NORMAL_FONTSIZE 10
#define IPAD_DETAIL_VIEW_MARGIN 5
#define IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH 320
#define IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH 5
#define IPAD_WIDGET_INTERNAL_PADDING 5
#define IPAD_SPLITTER_DIV_WIDTH 15
#define IPAD_WIDGET_SECTION_TITLE_HEIGHT 20

#define IPHONE_TABLE_FONTSIZE 10
#define IPHONE_SCREEN_WIDTH 320
#define IPHONE_SCREEN_HEIGHT 480
#define IPHONE_LOADER_SIZE 25
#define IPHONE_NAVIGATION_TITLE_WIDTH 250
#define IPHONE_NAVIGATION_TITLE_HEIGHT 30
#define IPHONE_TITLE_BIG_FONTSIZE 20
#define IPHONE_TITLE_NORMAL_FONTSIZE 9
#define IPHONE_TABLE_TITLESIZE 15
#define IPHONE_SERVER_DETAIL_VIEW_WIDTH 320
#define IPHONE_WIDGET_PADDING 3

#define MATRICS_TABLE_WIDTH 250
#define PROCESS_TABLE_LANDSCAPE_HEIGHT 320
#define PROCESS_TABLE_PORTRAIT_HEIGHT 455
#define IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT 465//300
#define IPAD_ALERT_DATA_TABLE_PORTRAIT_HEIGHT 350//300
#define IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT 320//175
#define IPAD_ALERT_DATA_TABLE_LANDSCAPE_HEIGHT 350//170


#define DISK_CHART_WIDTH 120
#define DISK_CHART_HEIGHT 120

#define IPAD_DISK_PIE_WIDTH 60
#define IPAD_DISK_PIE_HEIGHT 60

#define CPU_LABEL_WIDTH 50
#define ALERT_CELL_HEIGHT 40
#define ALERT_CELL_WIDTH 300

#define ALERT_TAB_NORMAL_FONT_SIZE 13.5
#define DASHBOARD_TAB_NORMAL_FONT_SIZE 12
#define DASHBOARD_TAB_SMALL_FONT_SIZE 10.5

#define IPHONE_TABLE_ROW_HEIGHT 25

#define DEV_SERVER_IP @"https://192.168.1.102"
#define PROD_SERVER_IP @"https://wwws.appfirst.com"


#define LOGIN_API_STRING @"/api/iphone/login/"
#define SERVER_LIST_API_STRING @"/widget/server_widget/api/iphone/data/preview/"
#define SERVER_DETAIL_API_STRING @"/widget/server_widget/api/iphone/data/system/"
#define SERVER_PROCESS_LIST_API_STRING @"/widget/server_widget/api/iphone/data/processes/"
#define SERVER_POLLDATA_API_STRING @"/widget/polled_data/api/iphone/data/"
#define SERVER_ALERT_API_STRING @"/widget/poll_data/iphone/data/preview/"
#define NOTIFICATION_API_STRING @"/widget/alert_history/api/iphone/data/"
#define BADGE_SET_API_STRING @"/api/iphone/badge/set/"
#define UUID_SET_API_STRING @"/api/iphone/uid/set/"
#define POLLDATA_GRAPH_API_STRING @"/widget/polled_data/api/iphone/graph/"

#define LIST_QUERY_COLUMN_NAME @"columns"
#define LIST_QUERY_DATA_NAME @"data"

#define ALERT_LIST_API_STRING @"/api/iphone/alertlist/"
#define ALERT_EDIT_API_STRING @"/api/iphone/alert/edit/"

#define PI 3.14159265358979323846

#define DEBUGGING NO

#define CPU_DISPLAY_TEXT @"CPU"
#define MEMORY_DISPLAY_TEXT @"Memory"
#define DISK_PERCENT_DISPLAY_TEXT @"Disk percentage"
#define PAGE_FAULT_DISPLAY_TEXT @"Page faults"
#define THREAD_NUM_DISPLAY_TEXT @"Thread count"
#define PROCESS_NUM_DISPLAY_TEXT @"Running processes"
#define DISK_BUSY_DISPLAY_TEXT @"Disk busy"

#define SOCKET_NUM_DISPLAY_TEXT @"Network connections"
#define SOCKET_READ_DISPLAY_TEXT @"Inbound network traffic"
#define SOCKET_WRITE_DISPLAY_TEXT @"Outbound network traffic"

#define FILE_NUM_DISPLAY_TEXT @"File accessed"
#define FILE_READ_DISPLAY_TEXT @"File read"
#define FILE_WRITE_DISPLAY_TEXT @"File write"

#define INCIDENT_REPORT_DISPLAY_TEXT @"Incidents report"
#define CRITICAL_INCIDENT_REPORT_DISPLAY_TEXT @"Critical incident resport"

#define REGISTRY_NUM_DISPLAY_TEXT @"Registry accessed"
#define AVG_RESPONSE_TIME_DISPLAY_TEXT @"Average response time"
#define RESPONSE_NUM_DISPLAY_TEXT @"Socket responses"


