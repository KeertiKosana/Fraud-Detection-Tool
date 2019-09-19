import {Component, Input, OnInit} from '@angular/core';
import {ListSortFieldSelectorModel} from '@blackbaud/skyux/dist/core';
import * as moment from 'moment';
import {Subscription} from 'rxjs/Subscription';

import {HeaderService} from '../services/header.service';
import {COData, COResult, JsonService, User} from '../services/json.service';

@Component({
  selector: 'app-common-results',
  templateUrl: './common-results.component.html',
  styleUrls: ['./common-results.component.css']
})
export class CommonResultsComponent implements OnInit {
  DataName: string = '';
  public CommonOutliersResults: COResult;
  public ResultsDataPath = '../assets/CommonData.json';
  public _SelectedData: COData[] = [];
  public DisplayedData: COData[] = [];
  selectedUser: User;
  ItemsPerPage: number = 10;
  @Input()
  CurrentPage: number = 1;
  ItemNumber: number = this.ItemsPerPage * 2;
  CurSortField:
      ListSortFieldSelectorModel = {fieldSelector: 'outlier', descending: true};

  @Input()
  set SelectedData(selectedData: COData[]) {
    this._SelectedData = this.sortData(selectedData, this.CurSortField);
    this.ItemNumber = this._SelectedData.length;
    this.updateDisplayedData();
  }
  get SelectedData() {
    return this._SelectedData;
  }

  constructor(
      private jsonService: JsonService, private headerService: HeaderService) {}

  ngOnInit() {
    this.getJSONCOResultsData();

    this.headerService.getState().subscribe((selectedUser: User) => {
      this.selectedUser = selectedUser;
      if (this.CommonOutliersResults)
        this.SelectedData = this.getUserCOData(this.selectedUser);
    });
  }

  getJSONCOResultsData() {
    this.jsonService.getJSONCO(this.ResultsDataPath)
        .subscribe((data: COResult) => {
          this.CommonOutliersResults = data;
          this.DataName = data.name;
          this.SelectedData = this.getUserCOData(this.selectedUser);
        });
  }

  getUserCOData(user: User) {
    let data: COData[];
    if (this.CommonOutliersResults) {
      data = this.CommonOutliersResults.data.filter((UserCOData: COData) => {
        if (user && user.USERSID !== -1)
          return UserCOData.userID === user.USERSID;
        else
          return true;
      });
    }
    return data;
  }

  getPageItems(items: any[], curPage: number, itemsPerPage: number) {
    let begIdx = (curPage - 1) * itemsPerPage;
    let endIdx = begIdx + itemsPerPage;
    return items.slice(begIdx, endIdx);
  }

  updateDisplayedData() {
    this.DisplayedData = this.getPageItems(
        this.SelectedData, this.CurrentPage, this.ItemsPerPage);
  }

  updateItemsNumber() {
    this.updateDisplayedData();
  }

  public sortData(data: any[], activeSort: ListSortFieldSelectorModel) {
    const sortField = activeSort.fieldSelector;
    const descending = activeSort.descending;
    return data
        .sort((a: any, b: any) => {
          let val1 = a[sortField];
          let val2 = b[sortField];
          if (val1 && typeof val1 === 'string') val1 = val1.toLowerCase();
          if (val2 && typeof val2 === 'string') val2 = val2.toLowerCase();
          let result = val1 > val2 ? 1 : -1;
          if (descending) {
            result *= -1;
          }
          return result;
        })
        .slice();
  }

  public sortChanged(activeSort: ListSortFieldSelectorModel) {
    this.CurSortField = activeSort;
    this._SelectedData = this.sortData(this._SelectedData, this.CurSortField);
    this.updateDisplayedData();
  }
}
