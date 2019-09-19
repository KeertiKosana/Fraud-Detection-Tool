import {Component, Input, OnInit} from '@angular/core';
import {ListSortFieldSelectorModel} from '@blackbaud/skyux/dist/core';
import * as moment from 'moment';
import {Subscription} from 'rxjs/Subscription';

import {HeaderService} from '../services/header.service';
import {JsonService, SpecialUseCaseData, User} from '../services/json.service';

@Component({
  selector: 'app-special-use-case-results',
  templateUrl: './special-use-case-results.component.html',
  styleUrls: ['./special-use-case-results.component.css']
})
export class SpecialUseCaseResultsComponent implements OnInit {
  UseCaseName: string = 'AddedBy UserName Matches PayeeName';
  public UseCaseData: SpecialUseCaseData[] = [];
  public UseCaseDataPath = '../assets/UseCase1.json';
  public _SelectedData: SpecialUseCaseData[] = [];
  public DisplayedData: SpecialUseCaseData[] = [];
  selectedUser: User;
  ItemsPerPage: number = 10;
  @Input()
  CurrentPage: number = 1;
  ItemNumber: number = this.ItemsPerPage * 2;
  CurSortField: ListSortFieldSelectorModel = {
    fieldSelector: 'CheckAmount',
    descending: true
  };

  @Input()
  set SelectedData(selectedData: SpecialUseCaseData[]) {
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
    this.getJSONUseCaseData();
    this.headerService.getState().subscribe((selectedUser: User) => {
      this.selectedUser = selectedUser;
      this.SelectedData = this.searchData(this.selectedUser.NAME);
    });
  }

  getJSONUseCaseData() {
    this.jsonService.getJSONSUC(this.UseCaseDataPath)
        .subscribe((data: SpecialUseCaseData[]) => {
          this.UseCaseData = data;
          this.SelectedData = this.searchData(this.selectedUser.NAME);
        });
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

  isInObjectValues(data: Object, text: string) {
    for (let key in data) {
      if (typeof data[key] === 'string' && data[key].indexOf(text) > -1)
        return true;
    }
    return false;
  }

  searchData(searchText: string) {
    if (searchText && searchText !== '' && this.UseCaseData) {
      let result;
      searchText = searchText.toLowerCase();
      result = this.UseCaseData.filter((data: SpecialUseCaseData) => {
        return this.isInObjectValues(data, searchText);
      });
      return result;
    } else {
      return this.UseCaseData;
    }
  }

  public sortData(data: any[], activeSort: ListSortFieldSelectorModel) {
    const sortField = activeSort.fieldSelector;
    const descending = activeSort.descending;
    return data
        .sort((a: any, b: any) => {
          let val1 = a[sortField];
          let val2 = b[sortField];
          let possDate1: moment.Moment;
          let possDate2: moment.Moment;

          if (val1) {
            if (typeof val1 === 'string') {
              val1 = val1.toLowerCase();
              possDate1 = moment(val1);
            }
          }
          if (val2) {
            if (typeof val2 === 'string') {
              val2 = val2.toLowerCase();
              possDate2 = moment(val2);
            }
          }
          let result;
          if (possDate1 && possDate2 && possDate1.isValid() &&
              possDate2.isValid()) {
            result = possDate1.diff(possDate2) > 0 ? 1 : -1;
          } else {
            result = val1 > val2 ? 1 : -1;
          }
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
